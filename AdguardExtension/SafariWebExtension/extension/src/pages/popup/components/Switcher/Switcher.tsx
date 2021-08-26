/* eslint-disable jsx-a11y/label-has-associated-control */
import React from 'react';

import './switcher.pcss';

interface SwitcherProps {
    onChange: () => void,
    enabled: boolean,
}

export const Switcher = ({ onChange, enabled }: SwitcherProps) => {
    return (
        <label className="switcher">
            <input
                className="switcher__checkbox"
                type="checkbox"
                onChange={onChange}
                checked={enabled}
            />
            <div className="switcher__inner" />
        </label>
    );
};
