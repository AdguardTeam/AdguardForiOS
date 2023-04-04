import React, { useContext, useEffect } from 'react';
import { observer } from 'mobx-react';

import { Icons } from '../../../common/ui/Icons';
import { useAppearanceTheme } from '../../../common/hooks/useAppearanceTheme';
import { Actions } from '../Actions';
import { Modals } from '../Modals';
import { popupStore } from '../../stores/PopupStore';
import { Support } from '../Support';
import { Loader } from '../Loader';
import { ExpandButton } from '../ExpandButton';
import { useFullscreen } from '../../hooks/useFullscreen';
import { log } from '../../../common/log';

import './popup.pcss';

export const Popup = observer(() => {
    const store = useContext(popupStore);

    useEffect(() => {
        (async () => {
            try {
                await store.getPopupData();
            } catch (e) {
                log.error(e);
            }
        })();
    }, []);

    useAppearanceTheme(store.appearanceTheme);

    useFullscreen((isFullscreen) => {
        store.setFullscreen(isFullscreen);
    });

    return (
        <div className="popup">
            <Icons />
            <Modals />
            <Actions />
            <Support />
            <ExpandButton />
            <Loader />
        </div>
    );
});
