export enum MessagesToNativeApp {
    WriteInNativeLog = 'writeInNativeLog',
    GetAdvancedRulesText = 'get_advanced_rules_text',
    GetInitData = 'get_init_data',
    ShouldUpdateAdvancedRules = 'should_update_advanced_rules',
}

export enum MessagesToBackgroundPage {
    OpenAssistant = 'open_assistant',
    AddRule = 'add_rule',
    GetPopupData = 'get_popup_data',
    SetPermissionsModalViewed = 'set_permissions_modal_viewed',
    SetProtectionStatus = 'set_protection_status',
    DeleteUserRulesByUrl = 'delete_user_rules_by_url',
    ReportProblem = 'report_problem',
    UpgradeClicked = 'upgrade_clicked',
    EnableAdvancedBlocking = 'enable_advanced_blocking',
    EnableSafariProtection = 'enable_safari_protection',
    WakeUp = 'wake_up',
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

export const WEB_EXTENSION_MORE_URL = 'https://link.adtidy.org/forward.html?action=web_extension_more&from=popup&app=ios';

export enum Platform {
    IPad = 'ipad',
    IPhone = 'iphone',
}

export const ADVANCED_RULES_STORAGE_KEY = 'AdvancedRulesStorageKey';

export const ENGINE_STORAGE_KEY = 'EngineStorageKey';
