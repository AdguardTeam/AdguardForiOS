import { useEffect } from 'react';

export const useFullscreen = (cb: (state: boolean) => void) => {
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
        };

        window.addEventListener('resize', resizeHandler);

        return () => {
            window.removeEventListener('resize', resizeHandler);
        };
    }, []);
};
