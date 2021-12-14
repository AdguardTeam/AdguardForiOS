import React, { ReactElement, ReactNode } from 'react';

import { Icon } from '../../ui/Icon';
import { Button } from '../../Button';

import './modal.pcss';

interface ModalProps {
    title?: string,
    description?: string | ReactNode,
    close: () => void,
    children?: ReactElement,
}

export const Modal = ({
    title,
    description,
    close,
    children,
}: ModalProps) => {
    return (
        <div className="modal">
            <div className="modal__inner">
                <Button onClick={close} classNames="modal__close">
                    <Icon color="gray400" iconId="cross" />
                </Button>
                <div className="modal__title">
                    {title}
                </div>
                <div className="modal__description">
                    {description}
                </div>
                {children}
            </div>
        </div>
    );
};
