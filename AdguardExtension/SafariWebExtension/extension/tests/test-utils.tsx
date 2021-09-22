import React, { FC, ReactElement } from 'react';
import { render } from '@testing-library/react';
import { PopupStore, PopupStoreContext } from '../src/pages/popup/stores/PopupStore';

const customRender = (
    ui: ReactElement,
    {
        store = new PopupStore(),
        ...options
    } = {},
) => {
    const Wrapper: FC = ({ children }) => {
        return (
            <PopupStoreContext.Provider value={store}>
                {children}
            </PopupStoreContext.Provider>
        );
    };

    return render(ui, { wrapper: Wrapper, ...options });
};

export * from '@testing-library/react';
export { customRender as render };
