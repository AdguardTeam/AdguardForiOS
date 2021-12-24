import React, { useContext } from 'react';
import { observer } from 'mobx-react';

import { PopupDataLoadingState, popupStore } from '../../stores/PopupStore';

import './loader.pcss';

export const Loader = observer(() => {
    const store = useContext(popupStore);

    if (store.popupDataLoadingState !== PopupDataLoadingState.Loading) {
        return null;
    }

    return (
        <div className="loader">
            <div className="loader__inner">
                <div className="loader__item" />
                <div className="loader__item" />
                <div className="loader__item" />
                <div className="loader__item" />
            </div>
        </div>
    );
});
