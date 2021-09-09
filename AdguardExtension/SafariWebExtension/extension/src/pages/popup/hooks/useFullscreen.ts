import { useEffect, useRef } from 'react';

export const useFullscreen = (cb: (state: boolean) => void) => {
    const requestRef = useRef<number>();
    // We start detect min size of popup after an small timeout,
    // otherwise min size value can be too small
    const START_RESIZE_DETECT_TIMEOUT_MS = 100;

    useEffect(() => {
        let min = 0;
        let max = 0;

        const resizeHandler = () => {
            const FULLSCREEN_RATIO = 1.6;

            const currentHeight = window.innerHeight;

            if (!min) {
                min = currentHeight;
            } else if (currentHeight < min) {
                min = currentHeight;
            } else {
                max = currentHeight;
            }

            if (max && min && (max / min) > FULLSCREEN_RATIO) {
                cb(true);
            } else {
                cb(false);
            }
            requestRef.current = requestAnimationFrame(resizeHandler);
        };

        const timeoutId = setTimeout(() => {
            /**
             * window.onresize event doesn't fire reliable on real device, during swipes
             * that is why we use here requestAnimationFrame
             */
            requestRef.current = requestAnimationFrame(resizeHandler);
        }, START_RESIZE_DETECT_TIMEOUT_MS);

        return () => {
            if (timeoutId) {
                clearTimeout(timeoutId);
            }

            if (requestRef.current !== undefined) {
                cancelAnimationFrame(requestRef.current);
            }
        };
    }, []);
};
