function gotoUser(username) {
    location.href = `/stats/${username}`
}

function gotoProfile(username, profile) {
    location.href = `/stats/${username}/${profile}`
}