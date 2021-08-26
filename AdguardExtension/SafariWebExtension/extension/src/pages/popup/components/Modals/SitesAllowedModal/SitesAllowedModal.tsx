import React, { useContext } from 'react';
import { observer } from 'mobx-react';

import { Modal } from '../Modal';
import { translator } from '../../../../common/translators/translator';
import { Button } from '../../Button';
import { popupStore } from '../../../stores/PopupStore';

const CONTENT_MAP = {
    allowed: {
        title: translator.getMessage('popup_modal_all_sites_allowed_title'),
        desc: translator.getMessage('popup_modal_all_sites_allowed_desc'),
        button: translator.getMessage('popup_modal_all_sites_allowed_button'),
    },

    notAllowed: {
        title: translator.getMessage('popup_modal_not_all_sites_allowed_title'),
        desc: translator.getMessage('popup_modal_not_all_sites_allowed_desc'),
        button: translator.getMessage('popup_modal_not_all_sites_allowed_button'),
    },
};

export const SitesAllowedModal = observer(() => {
    const store = useContext(popupStore);

    const content = store.allSitesAllowed ? CONTENT_MAP.allowed : CONTENT_MAP.notAllowed;

    const setPermissionsModalViewed = async () => {
        await store.setPermissionsModalViewed();
    };

    return (
        <Modal
            title={content.title}
            description={content.desc}
            close={setPermissionsModalViewed}
        >
            <Button
                onClick={setPermissionsModalViewed}
                classNames="button--green button--l button--bottom"
            >
                {content.button}
            </Button>
        </Modal>
    );
});
