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
    AppearanceTheme = 'appearanceTheme',
    AreContentBlockersEnabled = 'areContentBlockersEnabled',
    UpgradeMe = 'upgradeMe',
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
    GetAppearanceTheme = 'get_appearance_theme',
}

export enum MessagesToContentScript {
    InitAssistant = 'init_assistant',
}

export enum AppearanceThemes {
    SYSTEM = 'SYSTEM',
    DARK = 'DARK',
    LIGHT = 'LIGHT',
}

export const APPEARANCE_THEME_DEFAULT = AppearanceThemes.SYSTEM;
