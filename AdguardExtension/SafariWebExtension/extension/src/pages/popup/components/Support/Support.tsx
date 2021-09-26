import React, { useContext } from 'react';
import cn from 'classnames';
import { observer } from 'mobx-react';

import { translator } from '../../../common/translators/translator';
import { popupStore } from '../../stores/PopupStore';
import { messenger } from '../../../common/messenger';

import './support.pcss';

export const Support = observer(() => {
    const store = useContext(popupStore);

    const supportMap: { [key:string]: { title?: string, desc: string, class?: string } } = {
        protectionDisabled: {
            desc: translator.getMessage('popup_protection_disabled_support_desc'),
        },
        popupFullscreen: {
            title: translator.getMessage('popup_fullscreen_support_title'),
            desc: translator.getMessage('popup_fullscreen_support_desc'),
            class: 'support--swipe',
        },
    };

    let supportType = null;

    const protectionDisabledVisible = !store.protectionEnabled && store.contentBlockersEnabled;

    if (protectionDisabledVisible) {
        supportType = supportMap.protectionDisabled;
    } else if (store.isFullscreen) {
        supportType = supportMap.popupFullscreen;
    }

    if (!supportType) {
        return null;
    }

    const supportClass = cn('support', supportType.class);

    const handleReportTouch = (e: React.MouseEvent<HTMLButtonElement>) => {
        e.preventDefault();
        messenger.reportProblem(store.currentSiteUrl);
    };

    return (
        <div className={supportClass}>
            {supportType.title && (
                <div className="support__title">
                    {supportType.title}
                </div>
            )}
            <div className="support__description">
                {supportType.desc}
            </div>
            <button type="button" className="support__link" onClick={handleReportTouch}>
                {translator.getMessage('popup_support_button_text')}
            </button>
        </div>
    );
});
