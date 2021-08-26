import React from 'react';
import ReactDOM from 'react-dom';

import { Popup } from './components/Popup';

const init = () => {
    ReactDOM.render(
        <Popup />,
        document.getElementById('root'),
    );
};

export const popup = {
    init,
};
