import React, { useContext } from 'react';
import { observer } from 'mobx-react';
import browser from 'webextension-polyfill';

import { Modal } from '../Modal';
import { WEB_EXTENSION_MORE_URL } from '../../../../common/constants';
import { reactTranslator } from '../../../../common/translators/reactTranslator';
import { translator } from '../../../../common/translators/translator';
import { Button } from '../../Button';
import { popupStore } from '../../../stores/PopupStore';

const link = (text: string) => {
    const handleClick = async () => {
        await browser.tabs.create({ url: WEB_EXTENSION_MORE_URL });
    };

    return (
        // eslint-disable-next-line max-len
        // eslint-disable-next-line jsx-a11y/no-static-element-interactions,jsx-a11y/anchor-is-valid,jsx-a11y/click-events-have-key-events
        <a onClick={handleClick} className="link">
            {text}
        </a>
    );
};

const CONTENT_MAP = {
    allowed: {
        title: translator.getMessage('popup_modal_all_sites_allowed_title'),
        desc: translator.getMessage('popup_modal_all_sites_allowed_desc'),
        button: translator.getMessage('popup_modal_all_sites_allowed_button'),
    },

    notAllowed: {
        title: translator.getMessage('popup_modal_not_all_sites_allowed_title'),
        desc: reactTranslator.getMessage('popup_modal_not_all_sites_allowed_desc', { a: link }),
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
