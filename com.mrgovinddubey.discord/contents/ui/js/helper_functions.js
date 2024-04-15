document.userScripts = { saveData: {}, config: {} };

document.userScripts.getMainInput = function() {
    return document.querySelector('textarea.m-0');
}

document.userScripts.getSendButton = function() {
    const sendButton = document.querySelector('textarea.m-0 + button.p-1');
    if (sendButton) {
        return sendButton;
    } else {
        console.error("Send button not found");
        return null;
    }
}

document.userScripts.setInputFocus = function() {
    let inputElement = document.userScripts.getMainInput();
    if (inputElement) {
        inputElement.focus();
    }
    console.log('setInputFocus');
}

document.userScripts.setSendOnEnter = function() {
    let inputElement = document.userScripts.getMainInput();
    let sendButton = document.userScripts.getSendButton();

    if (inputElement && sendButton && !document.userScripts.saveData.oldOnPress) {
        document.userScripts.saveData.oldOnPress = inputElement.onkeypress;
        inputElement.onkeypress = function(e) {
            if (e.keyCode === 13 && !e.shiftKey && !e.ctrlKey && document.userScripts.config.sendOnEnter) {
                sendButton.click();
                return false;
            }
        }
    }
    console.log('setSendOnEnter');
}

document.userScripts.setTheme = function(theme) {
    if (document.userScripts.config && document.userScripts.config.matchTheme && theme) {
        localStorage.setItem('theme', theme);
        console.log('setTheme');
    }
}

document.userScripts.getTheme = function() {
    return localStorage.getItem('theme');
}

document.userScripts.removeSendOnEnter = function() {
    let inputElement = document.userScripts.getMainInput();
    if (inputElement) {
        inputElement.onkeypress = document.userScripts.saveData.oldOnPress;
        document.userScripts.saveData.oldOnPress = null;
    }
    console.log('removeSendOnEnter');
}

document.userScripts.setConfig = function(configuration) {
    document.userScripts.config = configuration;
    console.log('setConfig : ' + JSON.stringify(configuration));
}

// Inject custom CSS styles to increase the width of the Discord window
const customCSS = `
    /* Increase the width of the Discord window */
    .discord-window {
        width: 1600px; /* You can adjust the width as needed */
    }
`;

const styleElement = document.createElement('style');
styleElement.innerHTML = customCSS;
document.head.appendChild(styleElement);

console.log('Helper Functions loaded');
