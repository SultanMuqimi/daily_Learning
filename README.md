# 📚 Daily Learning Activity Tracker

Automatically maintain your GitHub contribution streak with daily commits!

## 🌟 Features

- **Automated Daily Commits**: Automatically adds activity entries and commits to GitHub
- **Configurable Schedule**: Set up to run at your preferred time(s) each day
- **Smart Activity Tracking**: Prevents duplicate entries and limits updates per day
- **Random Time Offsets**: Makes commits look more natural with randomized timestamps
- **Comprehensive Logging**: Track all activities in `activity_log.txt`
- **Error Handling**: Robust error handling with detailed logging
- **Windows Task Scheduler Integration**: Easy setup with PowerShell script

## 🚀 Quick Start

### Prerequisites

- Python 3.6 or higher
- Git configured with your credentials
- Windows OS (for Task Scheduler automation)

### Installation

1. **Clone this repository** (if not already cloned):
   ```bash
   git clone https://github.com/SultanMuqimi/daily_Learning
   cd daily_Learning
   ```

2. **Test the script manually**:
   ```bash
   python daily_activity.py
   ```
   Or double-click `run_daily_activity.bat`

3. **Set up automated daily runs**:
   - Right-click `setup_task_scheduler.ps1`
   - Select "Run with PowerShell as Administrator"
   - Follow the prompts to configure your preferred schedule

## ⚙️ Configuration

Edit `config.json` to customize behavior:

```json
{
  "activity_file": "activity.txt",
  "commit_message_templates": [
    "Daily learning activity",
    "Updated daily progress",
    "Keep the streak alive!"
  ],
  "random_time_offset": true,
  "max_entries_per_day": 3,
  "auto_push": true
}
```

### Configuration Options

| Option | Description | Default |
|--------|-------------|---------|
| `activity_file` | Name of the activity tracking file | `activity.txt` |
| `commit_message_templates` | List of random commit messages to use | Multiple options |
| `random_time_offset` | Add ±30 min random offset to timestamps | `true` |
| `max_entries_per_day` | Maximum activity entries per day | `3` |
| `auto_push` | Automatically push to GitHub | `true` |

## 📝 Files Description

- **`daily_activity.py`** - Main Python script that handles activity tracking and git operations
- **`run_daily_activity.bat`** - Windows batch file for easy manual execution
- **`run_daily_activity.ps1`** - PowerShell script for advanced automation
- **`setup_task_scheduler.ps1`** - Automated setup script for Windows Task Scheduler
- **`config.json`** - Configuration file for customizing behavior
- **`activity.txt`** - Activity tracking file (DO NOT EDIT MANUALLY)
- **`activity_log.txt`** - Execution log file
- **`README.md`** - This file

## 🔧 Manual Task Scheduler Setup

If you prefer to set up Task Scheduler manually:

1. Press `Win + R` and type `taskschd.msc`
2. Click "Create Basic Task"
3. Name: `DailyLearningActivity`
4. Trigger: Daily
5. Action: Start a program
6. Program: `C:\Users\RAFO\source\repos\Daily_Learning\daily_Learning\run_daily_activity.bat`
7. Start in: `C:\Users\RAFO\source\repos\Daily_Learning\daily_Learning`

## 📊 How It Works

1. **Script runs** (manually or via Task Scheduler)
2. **Loads configuration** from `config.json`
3. **Checks existing entries** for today to avoid duplicates
4. **Adds new activity entry** with current timestamp (± random offset)
5. **Commits changes** to git with a random commit message
6. **Pushes to GitHub** to update your contribution graph
7. **Logs everything** to `activity_log.txt`

## 🐛 Troubleshooting

### Script fails to push to GitHub

- Ensure your git credentials are configured:
  ```bash
  git config --global user.name "Your Name"
  git config --global user.email "your.email@example.com"
  ```
- Check if you have push access to the repository
- Verify your GitHub authentication (SSH key or HTTPS token)

### Python not found

- Install Python from [python.org](https://www.python.org/)
- Make sure Python is added to PATH during installation
- Restart your terminal after installation

### Task doesn't run automatically

- Check Task Scheduler (taskschd.msc) for error messages
- Ensure the task is enabled
- Check `activity_log.txt` for error details
- Verify the script path in Task Scheduler is correct

### "Access Denied" when setting up Task Scheduler

- Right-click PowerShell and select "Run as Administrator"
- Ensure you have administrative privileges on your computer

## 🎯 Tips for Best Results

1. **Set multiple times**: Run 2-3 times per day for more natural-looking activity
2. **Use random offsets**: Keep `random_time_offset: true` for varied commit times
3. **Monitor the log**: Check `activity_log.txt` regularly to ensure everything is working
4. **Test first**: Run manually a few times before setting up automation
5. **Backup regularly**: Your activity history is in `activity.txt`

## 📈 Advanced Usage

### Run Multiple Times Per Day

Edit the Task Scheduler task or create multiple tasks:
- Morning: 9:00 AM
- Afternoon: 2:00 PM  
- Evening: 8:00 PM

### Custom Commit Messages

Add your own messages to `commit_message_templates` in `config.json`:
```json
{
  "commit_message_templates": [
    "📚 Daily learning session",
    "🚀 Progress update",
    "💪 Keep pushing forward",
    "🎯 Daily goal achieved"
  ]
}
```

### Disable Auto-Push

Set `"auto_push": false` in `config.json` to only commit locally. You can then manually push when desired.

## 📜 License

This project is open source and available for personal use.

## 🤝 Contributing

Feel free to submit issues and enhancement requests!

## ⚠️ Disclaimer

This tool is for personal learning and development tracking. Use responsibly and in accordance with GitHub's Terms of Service. Maintain genuine contributions alongside automated ones.

---

**Happy Learning! 🎓**
