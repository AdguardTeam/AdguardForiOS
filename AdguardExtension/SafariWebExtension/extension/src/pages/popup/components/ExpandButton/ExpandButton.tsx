import React, { useContext } from 'react';
import { observer } from 'mobx-react';

import { popupStore } from '../../stores/PopupStore';
import { Platforms } from '../../../common/constants';

export const ExpandButton = observer(() => {
    const store = useContext(popupStore);

    if (store.platform !== Platforms.IPad) {
        return null;
    }

    const handleExpandClick = () => {
        store.togglePopupExpanded();
    };

    return (
        <div
            onClick={handleExpandClick}
        >
            button
        </div>
    );
});
