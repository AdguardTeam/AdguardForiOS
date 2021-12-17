import React, { useContext } from 'react';
import { observer } from 'mobx-react';

import { Icon } from '../ui/Icon';
import { popupStore } from '../../stores/PopupStore';
import { Platforms } from '../../../common/constants';
import { Button } from '../Button';

export const ExpandButton = observer(() => {
    const store = useContext(popupStore);

    if (store.platform !== Platforms.IPad
        // hide button after popup is expanded because safari doesn't allow to shrink it back
        || store.popupExpanded) {
        return null;
    }

    const handleExpandClick = () => {
        store.togglePopupExpanded();
    };

    return (
        <Button
            onClick={handleExpandClick}
            classNames="button--roll"
        >
            <Icon iconId="arrow" />
        </Button>
    );
});
