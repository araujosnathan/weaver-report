
# against jira.atlassian.com.
from jira import JIRA
import re

class Bug:
    total_backlog = 0
    total_fixed = 0
    total_flagged = 0
    query_backlog = ""
    query_sprint_bug_unresolved = ""
    query_sprint_bug_fixed = ""
    query_sprint_bug_flagged = ""
    list_bugs_flagged = ()
    jira = ()
    
    def __init__(self, jira, query_backlog, query_sprint_bug_unresolved, query_sprint_bug_fixed, query_sprint_bug_flagged, query_backlog_flagged):
        self.jira = jira
        self.query_backlog = query_backlog
        self.query_sprint_bug_unresolved = query_sprint_bug_unresolved
        self.query_sprint_bug_fixed = query_sprint_bug_fixed
        self.query_sprint_bug_flagged = query_sprint_bug_flagged
        self.query_backlog_flagged = query_backlog_flagged 
    
    def get_jira_bugs_backlog(self):
        issues_in_proj = self.jira.search_issues(self.query_backlog)
        issues_in_proj = issues_in_proj + self.jira.search_issues(self.query_sprint_bug_unresolved)
        return len(issues_in_proj)

    def get_jira_bugs_fixed(self):
        issues_in_proj = self.jira.search_issues(self.query_sprint_bug_fixed)
        return len(issues_in_proj)

    def get_jira_bugs_flagged(self):
        issues_in_proj = self.jira.search_issues(self.query_backlog_flagged)
        issues_in_proj = issues_in_proj + self.jira.search_issues(self.query_sprint_bug_flagged)
        self.list_bugs_flagged = issues_in_proj
        return len(issues_in_proj)

    def get_total_backlog(self):
        self.total_backlog = self.get_jira_bugs_backlog()
        return self.total_backlog
    
    def get_total_fixed(self):
        self.total_fixed = self.get_jira_bugs_fixed()
        return self.total_fixed

    def get_total_flagged(self):
        self.total_flagged = self.get_jira_bugs_flagged()
        return self.total_flagged
    
    def get_list_bugs_flagged(self):
        return self.list_bugs_flagged

    def print_list_bugs_flagged(self):
        for bugs in self.list_bugs_flagged:
            print('{}: {}'.format(bugs.key, bugs.fields.summary))



# By default, the client will connect to a JIRA instance started from the Atlassian Plugin SDK
# (see https://developer.atlassian.com/display/DOCS/Installing+the+Atlassian+Plugin+SDK for details).
# Override this with the options parameter.