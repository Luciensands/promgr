class BuildSlackMessageService
  attr_reader :task

  def call(task)
    @task = task
    [
      {
        "type": "section",
        "text": {
          "type": "mrkdwn",
          "text": ":exclamation: *New task added*\n*Title: #{task.task_title}*\nDue date: #{task.due_date.strftime("%a %b %e at %l:%M %p")}"
        }
      },
      {
        "type": "section",
        "text": {
          "type": "mrkdwn",
          "text": "#{task.users.pluck(:name).join(', ')} please check the task details and contact your manager if you have any questions.\n\n<https://www.promgr.tech/dashboard|View task details>"
        }
      }
    ]
  end

  def clock_in_reminder
    [
      {
        "type": "section",
        "text": {
          "type": "mrkdwn",
          "text": "Good morning everyone. Remember to clock in."
        },
      },
      {
        "type": "actions",
        "block_id": "actionblock1",
        "elements": [
          {
            "type": "button",
            "text": {
              "type": "plain_text",
              "text": "Clock in now"
            },
            "style": "primary",
            "value": "clock_in"
          }
        ]
      }
    ]
  end

  def timelog(timesheet)
    @timesheet = timesheet
    [
      {
        "type": "section",
        "text": {
          "type": "mrkdwn",
          "text": " #{@timesheet.user.name} logged in at #{@timesheet.time_in} "
        },
      }
    ]
  end

  def timeout(timesheet)
    @timesheet = timesheet
    [
      {
        "type": "section",
        "text": {
          "type": "mrkdwn",
          "text": " #{@timesheet.user.name} logged out at #{@timesheet.time_out} "
        },
      }
    ]
  end
end
