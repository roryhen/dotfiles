---
name: standup
description: >-
  Produce a stand-up update from my assigned Jira tickets: a
  "previous work" list (tickets touched on the current day or the previous
  working day) and an "upcoming work" list (Not Started tickets in priority
  order, falling back to the Backlog). Each ticket is a link, a short summary
  and its status. Use when asked for a stand-up, standup update, daily update,
  or "what did I do yesterday / what's next".
---

# Stand-up update

Read-only for Jira and git. This skill prints a stand-up and copies the day's
work into the notes repo. It never transitions, edits, comments on, or assigns
tickets.

## Inputs

- **Day** (optional). Default: the previous working day. Accept:
  - `today` / `current day`: the window is today from 00:00 to now.
  - `yesterday` / `day before` / no value: the previous working day. Skip
    weekends, so on a Monday this is Friday. Say which date was used in the
    heading.
- Nothing else is needed. The board comes from the config.

## Config

Read `~/.config/standup/config.md` first. It holds the Jira cloud ID and site,
the ticket link base, the project key, status names, commit key pattern,
notes repo paths, priority names, and any extra repos to check. If it is
missing, say so, point to `config.example.md` in this skill's directory, and
stop. Below, `<PROJECT>`, `<KEY>`, `<NOT_STARTED>`, `<BACKLOG>` and
`<LINK_BASE>` mean the matching config values.

If a call fails with an unknown site, run `getAccessibleAtlassianResources`
and use the `cloudId` that matches the configured site.

Current user: `currentUser()` in JQL. No account lookup is needed.

Call Atlassian tools from codemode as `tools.mcp__atlassian__<name>({...})`.
Use `view: "compact"` for list queries. Ask for `view: "evidence"` only when a
ticket's content matters for the summary.

## Procedure

1. **Work out the window.** Write the target day's start and end as
   `YYYY-MM-DD` dates. Use the user's local timezone. Use `today` as the
   start and `now` as the end for "today".

2. **Previous work.** Find tickets I was assigned that had activity in the
   window:

   ```sql
   project = <PROJECT> AND assignee = currentUser()
     AND updated >= "<start>" AND updated < "<end-exclusive>"
   ORDER BY updated DESC
   ```

   Use `searchJiraIssuesUsingJql` with `fields: ["summary","status","priority","issuetype"]`.
   Page with `nextPageToken` until `isLast` is true.

   For each ticket, judge whether the activity was real work or just noise
   (a label bump or a watcher-only change). Keep tickets with a status change,
   a comment by me, or a related commit. Check:
   - status transitions with `listJiraIssueChangelogs`. It is not in the
     default tool list, so find it with `discover` (query: "list jira issue
     changelogs"). The `changelog` expand on `getJiraIssue` also works for
     the newest page only.
   - my comments with `listJiraIssueComments` (`orderBy: "-created"`)
   - commits: run `git log --all --since="<start>" --until="<end>" --author="$(git config user.email)" --oneline`
     in the repo, and match keys with `--grep` using the configured commit key
     pattern. Also check the extra repos named in the config.

   Write each summary as one short line about what was done in the window,
   based on that evidence. Do not invent progress. If the evidence is thin,
   say so in the summary, for example "status moved to In Review; no commits
   in window".

3. **Upcoming work.** Take the first source that has results:

   a. My Not Started tickets, highest priority first:

   ```sql
   project = <PROJECT> AND assignee = currentUser() AND status = "<NOT_STARTED>"
   ORDER BY priority DESC, rank ASC
   ```

   b. Only if (a) returns nothing: Backlog tickets, highest priority first.
   These are usually unassigned. Do not assign them. Mark them as backlog
   in the output.

   ```sql
   project = <PROJECT> AND status = "<BACKLOG>" ORDER BY priority DESC, rank ASC
   ```

   Show up to 5 upcoming tickets. Use the same link and summary format. The
   status is always the real status name.

4. **Exclude tickets that appear in both lists.** A ticket that moved to
   In Progress or In Review during the window stays in previous work, even if
   it is still assigned. Do not put it in upcoming.

5. **Output.** Wrap the whole stand-up in a fenced ```markdown code block so
   the link syntax survives copying. Rendered Markdown loses the link
   syntax when copied, so do not print it outside the block. Use this shape
   inside the block:

   ````
   ```markdown
   ## Stand-up: <weekday d Mon> (<previous working day | today>)

   **Previous work**
   - [<KEY>-101](<LINK_BASE>): <one-line summary>. Status: In Review

   **Upcoming**
   - [<KEY>-102](<LINK_BASE>): <one-line summary>. Status: Not Started
   - [<KEY>-103](<LINK_BASE>): <one-line summary>. Status: Backlog (from backlog; unassigned)
   ```
   ````

   Keep it short. One line per ticket, no nested bullets. If a list is empty,
   write "None" under that heading. Do not add an attribution signature. This
   is chat output, not an external post.

## Copy to the notes repo

After the stand-up is printed, also write the matching day's work into the
notes repo from the config. Skip this section if the config has no notes repo. Do this for every run, including `today`. The
notes are organized by year and week, so the day goes into its week's file.

1. **Find the week file.** It is the configured week file path,
   where `<year>` is the 4-digit year of the day. `<name>` is the Monday to
   Friday range in this form: `October 26-30`, `June 29-July 3`,
   `August 31-September 4`. Use the full month name for both ends when the
   week crosses a month. Look at the existing files in that year folder to
   confirm the pattern. The day's week is the Monday to Friday containing it.
   If the Saturday or Sunday is the target, use the Friday's week.

2. **Create the file only if it is missing.** Copy
   the configured week template. Set `title` to
   `<Month d-d>, <year>` and `date` to that week's Monday as `YYYY-MM-DD`.
   Keep the `## Monday` to `## Friday` headings.

3. **Fill the day's section only.** Find `## <Weekday>` for the target day. Its
   section ends at the next `## ` heading or the end of the file. Replace a
   lone `-` placeholder with the entries. If the section already has entries,
   keep them and add only the new ones. Never rewrite or delete lines that
   are already there, because the user may have written them.

4. **Entry format.** Use the same line format as the stand-up, one line per
   ticket, so the notes match what was printed:

   ```markdown
   - [<KEY>-101](<LINK_BASE>): <one-line summary>. Status: In Review
   ```

   Do not use the `| <Status>` style that the older notes use. Copy the
   summary and status exactly as the stand-up has them.

5. **Do not commit.** The notes repo is the user's. Leave the change
   uncommitted and report the file path and the lines added.

6. **Report what was written.** Say which file and section were changed. If
   the day's section already had entries, say that, and list what was added
   and what was skipped as a duplicate.

## Gotchas

- The `updated` field also moves when someone else edits a ticket. Filtering
  by my comments, transitions, or commits gives a better signal than
  `updated` alone.
- `resolved` / `statusCategory = Done` tickets from the window also count as
  previous work. Include them.
- Priority names come from the config. Sort by the priority order the server returns, not by string.
- If Atlassian tools are not available or are not authorized, say so plainly
  and stop. Do not guess ticket content.
- The notes repo may have uncommitted files from the user's own work. Do not
  touch them, and do not run `git add`, `git commit` or `git stash` there.
