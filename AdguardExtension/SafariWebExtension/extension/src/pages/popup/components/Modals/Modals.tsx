import React, { useContext } from 'react';
import { observer } from 'mobx-react';

import { popupStore } from '../../stores/PopupStore';
import { SitesAllowedModal } from './SitesAllowedModal';
import { UpgradeModal } from './UpgradeModal';
import { ProtectionDisabledModal } from './ProtectionDisabledModal';

export const Modals = observer(() => {
    const store = useContext(popupStore);

    if (!store.permissionsModalViewed) {
        return <SitesAllowedModal />;
    }

    if (store.upgradeModalVisible) {
        return <UpgradeModal />;
    }

    if (store.showProtectionDisabledModal) {
        return <ProtectionDisabledModal />;
    }

    return null;
});
