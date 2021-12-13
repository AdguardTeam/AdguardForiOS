import React, { ReactNode, useContext } from 'react';
import { observer } from 'mobx-react';

import { Action } from '../Action';
import { reactTranslator } from '../../../../common/translators/reactTranslator';
import { popupStore } from '../../../stores/PopupStore';

// TODO find out the link
const PERMISSIONS_LEARN_MORE_URL = 'https://kb.adguard.com';

export const Permissions = observer(() => {
    const store = useContext(popupStore);

    const handleClick = () => {
        console.log('insufficient permissions');
    };

    if (store.allSitesAllowed) {
        return null;
    }

    return (
        <Action
            iconId="info"
            iconColor="yellow"
            onClick={handleClick}
            title={reactTranslator.getMessage('popup_action_insufficient_permissions', {
                a: (chunks: ReactNode) => <a className="support__link" href={PERMISSIONS_LEARN_MORE_URL}>{chunks}</a>,
            })}
        />
    );
});
