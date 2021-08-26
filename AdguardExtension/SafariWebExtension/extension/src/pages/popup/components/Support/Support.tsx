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

    let mode;
    if (!store.protectionEnabled) {
        mode = supportMap.protectionDisabled;
    } else if (store.isFullscreen) {
        mode = supportMap.popupFullscreen;
    } else {
        return null;
    }

    const supportClass = cn('support', mode.class);

    const handleReportTouch = (e: React.MouseEvent<HTMLButtonElement>) => {
        e.preventDefault();
        messenger.reportProblem(store.currentSiteUrl);
    };

    return (
        <div className={supportClass}>
            {mode.title && (
                <div className="support__title">
                    {mode.title}
                </div>
            )}
            <div className="support__description">
                {mode.desc}
            </div>
            <button type="button" className="support__link" onClick={handleReportTouch}>
                {translator.getMessage('popup_support_button_text')}
            </button>
        </div>
    );
});
