import { useEffect, useRef } from 'react';

const isAboutHalfSize = (fullSize: number, size: number) => {
    const HALF_SIZE_MIN_RATIO = 0.4;
    const HALF_SIZE_MAX_RATIO = 0.6;
    const ratio = size / fullSize;
    return ratio > HALF_SIZE_MIN_RATIO && ratio < HALF_SIZE_MAX_RATIO;
};

export const useFullscreen = (cb: (state: boolean) => void) => {
    const requestRef = useRef<number>();

    useEffect(() => {
        let min = 0;
        let max = 0;

        const resizeHandler = () => {
            const FULLSCREEN_RATIO = 1.6;

            const currentHeight = window.innerHeight;
            const screenHeight = window.screen.height;

            if (!min && isAboutHalfSize(screenHeight, currentHeight)) {
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

        /**
         * window.onresize event doesn't fire reliable on real device, during swipes
         * that is why we use here requestAnimationFrame
         */
        requestRef.current = requestAnimationFrame(resizeHandler);

        return () => {
            if (requestRef.current !== undefined) {
                cancelAnimationFrame(requestRef.current);
            }
        };
    }, []);
};
