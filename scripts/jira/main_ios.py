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

bugiOS =  Bug(jira, query_backlog, query_sprint_bug_unresolved, query_sprint_bug_fixed, query_sprint_bug_flagged, query_backlog_flagged)
# print(bugiOS.get_total_backlog())
# print(bugiOS.get_total_fixed())
# print(bugiOS.get_jira_bugs_flagged())
# bugiOS.print_list_bugs_flagged()

with open('bugs_metric.txt', 'a') as the_file:
    the_file.write('ios ' + str(bugiOS.get_total_backlog()) + " " + str(bugiOS.get_total_fixed()) + " " + str(bugiOS.get_jira_bugs_flagged()) + "\n")

with open('bugs_flagged.txt', 'a') as the_file:
    for bugs in bugiOS.get_list_bugs_flagged():
        the_file.write('ios ' + bugs.key + " " + bugs.fields.summary + "\n")

