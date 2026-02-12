#!/usr/bin/env python3
"""
Daily Activity Tracker
Automatically updates activity.txt with current timestamp and commits to GitHub
"""

import os
import sys
import logging
import random
from datetime import datetime
from pathlib import Path
import subprocess
import json

# Set up logging
log_file = Path(__file__).parent / "activity_log.txt"
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(levelname)s - %(message)s',
    handlers=[
        logging.FileHandler(log_file, encoding='utf-8'),
        logging.StreamHandler(sys.stdout)
    ]
)

def load_config():
    """Load configuration from config.json if it exists"""
    config_file = Path(__file__).parent / "config.json"
    default_config = {
        "activity_file": "activity.txt",
        "commit_message_templates": [
            "Daily learning activity",
            "Updated daily progress",
            "Daily commit",
            "Learning progress update",
            "Daily development activity"
        ],
        "random_time_offset": True,
        "max_entries_per_day": 3,
        "auto_push": True
    }
    
    if config_file.exists():
        try:
            with open(config_file, 'r') as f:
                user_config = json.load(f)
                default_config.update(user_config)
                logging.info("Loaded configuration from config.json")
        except Exception as e:
            logging.warning(f"Failed to load config.json: {e}. Using defaults.")
    
    return default_config

def add_activity(config):
    """Add a new activity entry to the activity file"""
    activity_file = Path(__file__).parent / config["activity_file"]
    
    # Generate timestamp
    now = datetime.now()
    
    # Add random time offset if enabled (±30 minutes)
    if config["random_time_offset"]:
        offset_minutes = random.randint(-30, 30)
        from datetime import timedelta
        now = now + timedelta(minutes=offset_minutes)
    
    timestamp = now.strftime("%Y-%m-%d %H:%M:%S")
    activity_entry = f"Activity on {timestamp}\n"
    
    # Check if we already have entries for today
    today = now.strftime("%Y-%m-%d")
    existing_entries = 0
    
    if activity_file.exists():
        with open(activity_file, 'r') as f:
            content = f.read()
            existing_entries = content.count(f"Activity on {today}")
    
    # Limit entries per day if configured
    if existing_entries >= config["max_entries_per_day"]:
        logging.info(f"Already have {existing_entries} entries for today. Skipping.")
        return False
    
    # Append activity
    with open(activity_file, 'a') as f:
        f.write(activity_entry)
    
    logging.info(f"Added activity: {activity_entry.strip()}")
    return True

def git_commit_and_push(config):
    """Commit changes and push to GitHub"""
    repo_dir = Path(__file__).parent
    
    try:
        # Configure git (in case not set)
        subprocess.run(
            ["git", "config", "user.email", "automated@dailylearning.com"],
            cwd=repo_dir,
            capture_output=True,
            check=False
        )
        subprocess.run(
            ["git", "config", "user.name", "Daily Learning Bot"],
            cwd=repo_dir,
            capture_output=True,
            check=False
        )
        
        # Add changes
        result = subprocess.run(
            ["git", "add", config["activity_file"]],
            cwd=repo_dir,
            capture_output=True,
            text=True,
            check=True
        )
        logging.info("Git add successful")
        
        # Check if there are changes to commit
        status_result = subprocess.run(
            ["git", "status", "--porcelain"],
            cwd=repo_dir,
            capture_output=True,
            text=True,
            check=True
        )
        
        if not status_result.stdout.strip():
            logging.info("No changes to commit")
            return True
        
        # Commit changes
        commit_message = random.choice(config["commit_message_templates"])
        result = subprocess.run(
            ["git", "commit", "-m", commit_message],
            cwd=repo_dir,
            capture_output=True,
            text=True,
            check=True
        )
        logging.info(f"Git commit successful: {commit_message}")
        
        # Push to remote
        if config["auto_push"]:
            result = subprocess.run(
                ["git", "push"],
                cwd=repo_dir,
                capture_output=True,
                text=True,
                check=True
            )
            logging.info("Git push successful")
            logging.info("SUCCESS: Activity pushed to GitHub!")
        
        return True
        
    except subprocess.CalledProcessError as e:
        logging.error(f"Git operation failed: {e}")
        logging.error(f"Output: {e.output if hasattr(e, 'output') else 'N/A'}")
        logging.error(f"Stderr: {e.stderr if hasattr(e, 'stderr') else 'N/A'}")
        return False
    except Exception as e:
        logging.error(f"Unexpected error during git operations: {e}")
        return False

def main():
    """Main execution function"""
    logging.info("=" * 60)
    logging.info("Daily Activity Tracker - Starting")
    logging.info("=" * 60)
    
    try:
        # Load configuration
        config = load_config()
        
        # Add activity entry
        if add_activity(config):
            # Commit and push changes
            if git_commit_and_push(config):
                logging.info("Daily activity update completed successfully!")
                return 0
            else:
                logging.error("Failed to commit and push changes")
                return 1
        else:
            logging.info("Activity update skipped (max entries reached)")
            return 0
            
    except Exception as e:
        logging.error(f"Error in main execution: {e}", exc_info=True)
        return 1

if __name__ == "__main__":
    sys.exit(main())
