import React, { useContext } from 'react';
import { observer } from 'mobx-react';

import { popupStore } from '../../stores/PopupStore';
import { SitesAllowedModal } from './SitesAllowedModal';
import { UpgradeModal } from './UpgradeModal';
import { ProtectionModal } from './ProtectionModal';
import { AdvancedBlockingModal } from './AdvancedBlockingModal';

export const Modals = observer(() => {
    const store = useContext(popupStore);

    // When adding a new modal, add it to store.modalIsOpen

    if (!store.permissionsModalViewed) {
        return <SitesAllowedModal />;
    }

    if (store.upgradeModalVisible) {
        return <UpgradeModal />;
    }

    if (store.advancedBlockingModalVisible) {
        return <AdvancedBlockingModal />;
    }

    if (store.protectionModalVisible) {
        return <ProtectionModal />;
    }

    return null;
});
