export enum MessagesToNativeApp {
    WriteInNativeLog = 'writeInNativeLog',
    GetBlockingData = 'getBlockingData',
    AddToUserRules = 'addToUserRules',
    IsProtectionEnabled = 'isProtectionEnabled',
    EnableProtection = 'enableProtection',
    DisableProtection = 'disableProtection',
    HasUserRulesBySite = 'hasUserRulesBySite',
    RemoveUserRulesBySite = 'removeUserRulesBySite',
    ReportProblem = 'reportProblem',
    IsPremium = 'isPremium',
    GetAppearanceTheme = 'getAppearanceTheme',
    AreContentBlockersEnabled = 'areContentBlockersEnabled',
    UpgradeMe = 'upgradeMe',
    GetAdvancedRulesText = 'get_advanced_rules_text',
    GetInitData = 'get_init_data',
}

export enum MessagesToBackgroundPage {
    OpenAssistant = 'open_assistant',
    GetScriptsAndSelectors = 'get_scripts_and_selectors',
    AddRule = 'add_rule',
    GetPopupData = 'get_popup_data',
    SetPermissionsModalViewed = 'set_permissions_modal_viewed',
    SetProtectionStatus = 'set_protection_status',
    DeleteUserRulesByUrl = 'delete_user_rules_by_url',
    ReportProblem = 'report_problem',
    UpgradeClicked = 'upgrade_clicked',
}

export enum MessagesToContentScript {
    InitAssistant = 'init_assistant',
}

export enum AppearanceTheme {
    System = 'system',
    Dark = 'dark',
    Light = 'light',
}

export const APPEARANCE_THEME_DEFAULT = AppearanceTheme.System;
