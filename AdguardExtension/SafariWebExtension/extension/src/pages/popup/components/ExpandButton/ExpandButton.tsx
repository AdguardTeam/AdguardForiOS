import React, { useContext } from 'react';
import { observer } from 'mobx-react';

import { Icon } from '../ui/Icon';
import { popupStore } from '../../stores/PopupStore';
import { Platforms } from '../../../common/constants';
import { Button } from '../Button';

export const ExpandButton = observer(() => {
    const store = useContext(popupStore);

    const siteAllowlisted = store.allowlistInverted
        ? store.protectionEnabled
        : !store.protectionEnabled;

    if (store.platform !== Platforms.IPad
        // hide button after popup is expanded because safari doesn't allow to shrink it back
        || store.popupExpanded
        // when site is allowlisted we show support info without expanding popup
        || siteAllowlisted
    ) {
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
