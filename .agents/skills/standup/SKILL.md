---
name: standup
description: >-
  Produce a stand-up from my assigned Jira tickets: a "previous work" list
  (tickets I changed or commented on yesterday, 5am to 8pm Pacific) and an
  "upcoming work" list (queued tickets). Each item is a link, a short summary
  and its current status. Use when asked for a stand-up, standup update, daily
  update, or "what did I do yesterday / what's next".
---

# Stand-up

Read-only. This skill prints a stand-up and copies the same lines into the
notes repo. It never transitions, edits, comments on, or assigns tickets.

## Config

Read `~/.config/standup/config.md`. It holds the Jira cloud ID and site, the
ticket link base, the project key, status names, the notes repo paths and the
priority names. If it is missing, say so, point to `config.example.md` in this
skill's directory, and stop. Below, `<PROJECT>`, `<NOT_STARTED>`, `<BACKLOG>`
and `<LINK_BASE>` mean the matching config values.

If a call fails with an unknown site, run `getAccessibleAtlassianResources`
and use the `cloudId` for the configured site.

Use `searchJiraIssuesUsingJql` with `view: "compact"`. Current user is
`currentUser()` in JQL. Page with `nextPageToken` until `isLast` is true.

## Window

"Yesterday" is the previous working day: skip weekends, so on a Monday it is
Friday. The window is that day, 05:00 to 20:00 Pacific. Jira timestamps come
back in the Jira profile's timezone, so convert the window to that timezone
(check the `created` value on any returned change) before comparing.

## Procedure

1. **Candidates.** Find my tickets updated on or after the window's date:

   ```sql
   project = <PROJECT> AND assignee = currentUser()
     AND updated >= "<window date>"
   ORDER BY updated DESC
   ```

   `updated` also moves when other people edit a ticket, so check each one.

2. **Previous work.** For each candidate, keep it only if it has, inside the
   window:
   - a status change (`listJiraIssueChangelogs`, or the `changelog` expand on
     `getJiraIssue` for the newest page), or
   - a comment by me (`listJiraIssueComments`, `orderBy: "-created"`).

   Ignore link-only, assignment-only and label-only changes. A ticket that was
   assigned to me in the window but not worked on is not previous work.

3. **Upcoming work.** My `<NOT_STARTED>` tickets, highest priority first:

   ```sql
   project = <PROJECT> AND assignee = currentUser() AND status = "<NOT_STARTED>"
   ORDER BY priority DESC, rank ASC
   ```

   If that is empty, use `<BACKLOG>` tickets, highest priority first, up to 5.
   These are usually unassigned. Do not assign them, and mark them as backlog.
   Leave out any ticket already in previous work.

## Item format

Every item in both lists uses exactly this shape:

```markdown
- [<KEY>](LINK_BASE): <ticket summary>. Status: <current status>
```

- `<ticket summary>` is the Jira `summary` field. If it is too short to say
  what the ticket is about, or too long (more than about 70 characters), write
  a brief single line in changelog style instead: past tense, one line, the
  changes made, taken from the status changes and comments in the window. For
  example, "Fixed the publish validation hook and merged it."
- `<current status>` is always the ticket's latest status name, not the status
  it had during the window.
- Upcoming items use the same format.

## Output

Wrap the whole stand-up in a fenced ```markdown block so the link syntax
survives copying. Use this shape:

````
```markdown
## Stand-up: <weekday d Mon> (previous working day)

**Previous work**
- [UE-101](<LINK_BASE>): <ticket summary>. Status: In Review

**Upcoming**
- [UE-102](<LINK_BASE>): <ticket summary>. Status: Not Started
- [UE-103](<LINK_BASE>): <ticket summary>. Status: Backlog
```
````

If a list is empty, write "None" under its heading. Do not add an attribution
signature; this is chat output, not an external post.

## Copy to the notes repo

After printing, write the previous-work lines into the notes repo for the same
day. Skip this if the config has no notes repo.

1. **Week file.** It is `<notes repo>/Work Notes/<year>/<name>.md`, where
   `<name>` is the Monday to Friday range containing the day, such as
   `October 26-30` or `June 29-July 3`. Use the full month name for both ends
   when the week crosses a month. Check the year folder for the pattern.
2. **Create only if missing.** Copy the week template and set `title` to
   `<Month d-d>, <year>` and `date` to that Monday.
3. **Fill the day.** Find `## <Weekday>` for the day. Replace a lone `-`
   placeholder with the lines. If the section already has entries, add only
   lines that are not already there. Never rewrite or delete existing lines,
   because they may be the user's.
4. **Same lines.** Write the exact item lines from the stand-up. Do not commit.
5. **Report.** Say which file and section changed and which lines were added or
   skipped as duplicates.

## Gotchas

- `updated` moves for edits by other people, so filter on status changes and
  my comments.
- `resolved` / `statusCategory = Done` tickets from the window count as
  previous work.
- Sort priorities by the server's order, not by string.
- If Atlassian tools are unavailable or not authorized, say so plainly and
  stop. Do not guess ticket content.
- The notes repo may have uncommitted changes from the user. Do not run
  `git add`, `git commit` or `git stash` there.
