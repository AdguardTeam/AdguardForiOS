import React, { useContext } from 'react';
import { observer } from 'mobx-react';
import browser from 'webextension-polyfill';

import { translator } from '../../../../common/translators/translator';
import { popupStore } from '../../../stores/PopupStore';
import { Button } from '../../Button';
import { Modal } from '../Modal';
import { messenger } from '../../../../common/messenger';
import { WEB_EXTENSION_MORE_URL } from '../../../../common/constants';
import { reactTranslator } from '../../../../common/translators/reactTranslator';

export const AdvancedBlockingModal = observer(() => {
    const store = useContext(popupStore);

    const handleClose = () => {
        store.hideAdvancedBlockingModal();
    };

    const handleClick = async () => {
        await messenger.enableAdvancedBlocking();
        window.close();
    };

    const ReadMoreLink = (text: string) => {
        const handleReadMoreClick = async () => {
            await browser.tabs.create({ url: WEB_EXTENSION_MORE_URL });
        };

        return (
            // eslint-disable-next-line max-len
            // eslint-disable-next-line jsx-a11y/no-static-element-interactions,jsx-a11y/anchor-is-valid,jsx-a11y/click-events-have-key-events
            <a onClick={handleReadMoreClick} className="link">
                {text}
            </a>
        );
    };

    return (
        <Modal
            title={translator.getMessage('popup_modal_advanced_blocking_disabled_title')}
            // eslint-disable-next-line max-len
            description={reactTranslator.getMessage('popup_modal_advanced_blocking_disabled_description', { a: ReadMoreLink })}
            close={handleClose}
        >
            <Button
                onClick={handleClick}
                classNames="button--green button--l button--bottom"
            >
                {translator.getMessage('popup_modal_advanced_blocking_disabled_button')}
            </Button>
        </Modal>
    );
});
