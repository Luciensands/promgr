class BuildSlackMessageService
  def timeout(timesheet)
    @timesheet = timesheet
    [
      {
        "type": "section",
        "text": {
          "type": "mrkdwn",
          "text": " #{@timesheet.user.name} logged out at #{@timesheet.time_out} "
        }
      }
    ]
  end
end
