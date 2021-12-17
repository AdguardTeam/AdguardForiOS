import React from 'react';
import { observer } from 'mobx-react';

import { ProtectionToggle } from './ProtectionToggle';
import { DeleteUserRules } from './DeleteUserRules';
import { CurrentSite } from './CurrentSite';
import { BlockElement } from './BlockElement';
import { Permissions } from './Permissions';
import { ReportIssue } from './ReportIssue';

import './actions.pcss';

export const Actions = observer(() => {
    return (
        <div className="actions">
            <CurrentSite />
            <ProtectionToggle />
            <BlockElement />
            <Permissions />
            <DeleteUserRules />
            <ReportIssue />
        </div>
    );
});
