function gotoUser(username) {
    location.href = `/stats/${username}`
}

function gotoProfile(username, profile) {
    location.href = `/stats/${username}/${profile}`
}

function searchSubmit() {
    gotoUser(document.getElementById('searchField').value)
    return false;
}

function searchKeyPressed() {
    
}