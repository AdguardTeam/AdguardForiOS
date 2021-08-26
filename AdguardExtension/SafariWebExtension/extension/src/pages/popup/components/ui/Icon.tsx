import React from 'react';
import cn from 'classnames';

import { IconId } from '../../../common/ui/Icons';

interface IconProps {
    iconId: IconId;
    className?: string;
    color?: string;
}

export const Icon = ({ iconId, className, color }: IconProps) => {
    const iconClass = cn('icon', color && `icon--${color}`, className);

    return (
        <svg className={iconClass}>
            <use xlinkHref={`#${iconId}`} />
        </svg>
    );
};
