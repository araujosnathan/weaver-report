# This script shows how to use the client in anonymous mode
# against jira.atlassian.com.
from jira import JIRA
from class_bug import Bug
import re


options = { 'server': '' }
jira = JIRA(options, basic_auth=('', ''))

query_backlog = ''
query_sprint_bug_unresolved = ''
query_sprint_bug_fixed = ''
query_backlog_flagged = ''
query_sprint_bug_flagged = ''

bugiOS =  Bug(jira, query_backlog, query_sprint_bug_unresolved, query_sprint_bug_fixed, query_sprint_bug_flagged, query_backlog_flagged)
print(bugiOS.get_total_backlog())
print(bugiOS.get_total_fixed())
print(bugiOS.get_jira_bugs_flagged())
bugiOS.print_list_bugs_flagged()

with open('bugs_metric.txt', 'a') as the_file:
    the_file.write('ios ' + str(bugiOS.get_total_backlog()) + " " + str(bugiOS.get_total_fixed()) + " " + str(bugiOS.get_jira_bugs_flagged()) + "\n")

with open('bugs_flagged.txt', 'a') as the_file:
    for bugs in bugiOS.get_list_bugs_flagged():
        the_file.write('ios ' + bugs.key + " " + bugs.fields.summary + "\n")

query_backlog = ''
query_sprint_bug_unresolved = ''
query_sprint_bug_fixed = ''
query_backlog_flagged = ''
query_sprint_bug_flagged = ''


bugAndroid = Bug(jira, query_backlog, query_sprint_bug_unresolved, query_sprint_bug_fixed, query_sprint_bug_flagged, query_backlog_flagged)
print(bugAndroid.get_total_backlog())
print(bugAndroid.get_total_fixed())
print(bugAndroid.get_jira_bugs_flagged())
bugAndroid.print_list_bugs_flagged()

with open('bugs_metric.txt', 'a') as the_file:
    the_file.write('android ' + str(bugAndroid.get_total_backlog()) + " " + str(bugAndroid.get_total_fixed()) + " " + str(bugAndroid.get_jira_bugs_flagged()) + "\n")

with open('bugs_flagged.txt', 'a') as the_file:
    for bugs in bugAndroid.get_list_bugs_flagged():
        the_file.write('android ' + bugs.key + " " + bugs.fields.summary + "\n")

