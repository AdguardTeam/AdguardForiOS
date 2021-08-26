import React, { ReactElement } from 'react';
import cn from 'classnames';

import './button.pcss';

interface ButtonProps {
    onClick: () => void,
    classNames?: string,
    children?: ReactElement | string,
}

export const Button = ({ onClick, children, classNames }: ButtonProps) => {
    const buttonClass = cn('button', classNames);

    const handleClick = (e: React.MouseEvent<HTMLButtonElement>) => {
        e.preventDefault();
        onClick();
    };

    return (
        <button
            className={buttonClass}
            onClick={handleClick}
        >
            {children}
        </button>
    );
};
