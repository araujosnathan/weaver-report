from jira import JIRA
from class_bug import Bug
import re


options = { 'server': 'URL' }
jira = JIRA(options, basic_auth=('user', 'pass'))


query_backlog = ''
query_sprint_bug_unresolved = ''
query_sprint_bug_fixed = ''
query_backlog_flagged = ''
query_sprint_bug_flagged = ''


bugAndroid = Bug(jira, query_backlog, query_sprint_bug_unresolved, query_sprint_bug_fixed, query_sprint_bug_flagged, query_backlog_flagged)
# print(bugAndroid.get_total_backlog())
# print(bugAndroid.get_total_fixed())
# print(bugAndroid.get_jira_bugs_flagged())
# bugAndroid.print_list_bugs_flagged()

with open('bugs_metric.txt', 'a') as the_file:
    the_file.write('android ' + str(bugAndroid.get_total_backlog()) + " " + str(bugAndroid.get_total_fixed()) + " " + str(bugAndroid.get_jira_bugs_flagged()) + "\n")

with open('bugs_flagged.txt', 'a') as the_file:
    for bugs in bugAndroid.get_list_bugs_flagged():
        the_file.write('android ' + bugs.key + " " + bugs.fields.summary + "\n")

