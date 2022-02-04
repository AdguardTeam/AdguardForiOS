/**
 * A small helper function that detects when the video leaves picture-in-picture.
 * This is just a simple mitigation for the issue with handling "leaving" picture-in-picture.
 * We want to be sure that the video will return to full screen mode when the user leavs PiP,
 * but for some reason this behavior is not stable.
 */
function setupPip() {
    let video = document.querySelector('video');
    if (!video) {
        setTimeout(setupPip, 500);
        return;
    }

    video.addEventListener('leavepictureinpicture', () => {
        // 100 milliseconds is an experimental value, just letting YT scripts finish their work.
        // TODO: find better criteria.
        setTimeout(() => {
            if (video.requestFullscreen) {
                video.requestFullscreen();
            } else if (video.webkitEnterFullscreen) {
                video.webkitEnterFullscreen();
            }
        }, 100);
    });
}

window.addEventListener('load', setupPip);
