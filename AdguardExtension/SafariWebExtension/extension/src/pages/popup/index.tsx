import React from 'react';
import ReactDOM from 'react-dom';

import { popupStoreValue, PopupStoreContext } from './stores/PopupStore';
import { Popup } from './components/Popup';

const init = () => {
    ReactDOM.render(
        <PopupStoreContext.Provider value={popupStoreValue}>
            <Popup />
        </PopupStoreContext.Provider>,
        document.getElementById('root'),
    );
};

export const popup = {
    init,
};
