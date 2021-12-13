/* eslint-disable jsx-a11y/click-events-have-key-events, jsx-a11y/no-static-element-interactions */
import React, { ReactElement, ReactNode } from 'react';
import cn from 'classnames';

import { IconId } from '../../../../common/ui/Icons';
import { Icon } from '../../ui/Icon';

import './action.pcss';

interface ActionProps {
    iconId: IconId,
    iconColor?: string,
    iconDataUrl?: string
    title: string | ReactNode,
    titleMod?: string,
    description?: string,
    descriptionMod?: string,
    onClick?: () => void,
    children?: ReactElement,
    disable?: boolean,
}

export const Action = ({
    iconId,
    iconColor,
    iconDataUrl,
    title,
    titleMod,
    description,
    descriptionMod,
    onClick,
    children,
    disable,
}: ActionProps) => {
    const actionClass = cn('action', disable && 'action--disable');
    const titleClass = cn('action__title', titleMod && `action__title--${titleMod}`);
    const descriptionClass = cn('action__description', descriptionMod && `action__description--${descriptionMod}`);

    const handleClick = (e: React.MouseEvent<HTMLDivElement>) => {
        if (onClick) {
            e.preventDefault();
            onClick();
        }
    };

    let icon;

    if (iconDataUrl) {
        icon = <img className="icon" src={iconDataUrl} alt="favicon" />;
    } else {
        icon = <Icon iconId={iconId} color={iconColor} />;
    }

    return (
        <div className={actionClass} onClick={handleClick}>
            <div className="action__icon">
                {icon}
            </div>
            <div className="action__details">
                <div className={titleClass}>{title}</div>
                {description && (
                    <div className={descriptionClass}>{description}</div>
                )}
            </div>
            {children}
        </div>
    );
};
