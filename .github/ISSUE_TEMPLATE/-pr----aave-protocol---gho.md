---
name: "[PR] - Aave Protocol & GHO"
about: Describe this issue template's purpose here.
title: "[TokenLogic] <Description>"
labels: enhancement
assignees: ''

---

## Scope

Define: What the task sets out to achieve, and how it is to be achieved.

## Context

Provide any information that helps the person complete the task, and any client expectations and considerations to be mindful of? 

Forum Link:
Snapshot Link:

## Deliverable

Define exactly what is to be delivered, to whom it is being delivered, and what actions need to be completed for this task to be considered Complete.  

## Checklist

Before pushing any PR to the Bored Ghost Developing or Aave Labs Repository, complete the checklist below:

- [ ] I have run a spell check on the write-up and made sure no typos exist.
- [ ] References to Snapshot/governance forum are correct on the AIP. If no snapshot exists, make sure no TODOs exist.
- [ ] The specification on the writeup is aligned with the forum, snapshot, and the payload contract. - [ ] If there are any changes, they are explicitly mentioned/communicated.
- [ ] Minimal tests exist, and the snapshot diff report generated is the latest one and aligned with the payload.
- [ ] If deploy scripts are manually updated from the generated ones, I have carefully validated that they are correct, including the deploy commands and the proposal-creation script.
- [ ] If the aave-helpers submodule is updated, I have validated that it is pointing to the latest version.
- [ ] I have validated that no unused files or imports are being added.
- [ ] For an asset listing, the write-up includes a detailed specification of the price feed used, CAPO adapters (with each CAPO layer described separately), and eModes (with tables) if changed.
- [ ] Wherever possible, I have validated that addresses from the address book are used instead of raw addresses.
