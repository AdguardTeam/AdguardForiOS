import React, { useContext } from 'react';
import { observer } from 'mobx-react';

import { Action } from '../Action';
import { translator } from '../../../../common/translators/translator';
import { popupStore } from '../../../stores/PopupStore';

export const DeleteUserRules = observer(() => {
    const store = useContext(popupStore);

    const { hasUserRules, protectionEnabled, contentBlockersEnabled } = store;

    if (!hasUserRules || !protectionEnabled || !contentBlockersEnabled) {
        return null;
    }

    const handleClick = async () => {
        await store.deleteUserRules();
        window.close();
    };

    return (
        <Action
            iconId="delete"
            iconColor="red"
            onClick={handleClick}
            title={translator.getMessage('popup_action_delete_user_rules')}
        />
    );
});
