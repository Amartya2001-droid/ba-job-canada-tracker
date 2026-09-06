# Git Workflow Notes

This repo's git operations are sometimes slow or appear to hang. This is a known, recurring issue in this local clone, not repo corruption. This doc records what it looks like and the safe way to handle it.

## What It Looks Like

- `git status`, `git commit`, or `git push` runs far longer than normal (minutes instead of seconds) with the process sitting idle (near-zero CPU) rather than erroring out.
- No `.git/index.lock` file is present, so it is not the classic concurrent-git-process lock conflict.
- Retrying the same command, or simply giving it more time, resolves it. Observed on 2026-09-05: a `git commit` and a `git status` each took well over a minute before completing normally, with a disk at 95% capacity at the time. Disk pressure on this machine is the leading suspect, not something wrong with the repository itself.

## Safe Handling

1. **Do not repeatedly retry in a tight loop.** Each retry is another slow git process competing for the same I/O.
2. **Give it room.** Use a generous timeout (several minutes) before concluding it is actually stuck rather than just slow.
3. **Before killing a hung process, check for `.git/index.lock`.** If a lock file exists, a prior process may still be writing; investigate before removing it.
4. **If you do kill a hung `git commit`,** re-run `git status --short` afterward. A staged-but-uncommitted file (`M ` in the short status, not `MM` or untracked) confirms the add succeeded and the commit simply never finished, not that anything is corrupted. Re-running the same commit command is safe.
5. **Never use `--no-verify` or disable GPG signing to work around a hang** unless the user has explicitly asked for it. Slowness is not a reason to skip hooks or verification.
6. **If it keeps recurring,** the practical fix is freeing local disk space rather than repo surgery.
