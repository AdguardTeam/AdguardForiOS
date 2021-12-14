import React, { useContext } from 'react';
import { observer } from 'mobx-react';

import { popupStore } from '../../../stores/PopupStore';
import { Action } from '../Action';

export const ReportIssue = observer(() => {
    const store = useContext(popupStore);

    if (store.platform !== 'ipad') {
        return null;
    }

    return (
        <Action iconId="aim" title="Report an issue" />
    );
});
