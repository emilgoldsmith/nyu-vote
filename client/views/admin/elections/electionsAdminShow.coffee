Template.electionsAdminShow.helpers
  election: () ->
    election = Election.getActive()
    return election
  groups: () ->
    return _.map(@groups, (groupId) ->
      localGroup = Group.fetchOne(groupId)
      if localGroup
        localGroup.exists = true
        return localGroup
      else
        return  {
          _id: groupId
          exists: false
          name: "hidden group"
        }
    )
  canEdit: () ->
    this.status == "unopened" && this.hasAdmin(Meteor.user())
  openCloseElection: () ->
    if this.status == "open" then return "Close" else return "Open"
  openCloseClass: () ->
    if this.status == "open" then return "button-secondary" else return "button-success"
  type: () ->
    return this.options.type
  allowAbstain: () ->
    if this.options?.allowAbstain then return "Allows" else return "Forbids"
  multi: () ->
    if this.options?.multi then return "Multiple" else return "Single"

Template.electionsAdminShow.events
  "click .openCloseElection": (e) ->
    e.preventDefault()
    if (this.status != "unopened" ||
        confirm("Once you open this election, it can no longer be modified." +
        " Are you sure you want to do this?"))
      Meteor.call("toggleElectionStatus", this._id)