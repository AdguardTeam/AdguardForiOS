import type { CosmeticRule } from '@adguard/tsurlfilter';

/**
 * Builds stylesheets from rules.
 *
 * @param elemhideRules Element hiding rules
 * {@see https://adguard.com/kb/general/ad-filtering/create-own-filters/#cosmetic-elemhide-rules}.
 * @param injectRules CSS rules
 * {@see https://adguard.com/kb/general/ad-filtering/create-own-filters/#cosmetic-css-rules}.
 * @param groupElemhideSelectors Flag to group element hiding selectors. If set to true,
 * elemhide selector are to be combined into selector lists of {@link CSS_SELECTORS_PER_LINE}.
 *
 * @returns List of string rules.
 */
export const buildStyleSheet = (
    elemhideRules: CosmeticRule[],
    injectRules: CosmeticRule[],
    groupElemhideSelectors: boolean,
): string[] => {
    // number of selectors in grouped selector list
    const CSS_SELECTORS_PER_LINE = 50;
    const ELEMHIDE_CSS_STYLE = ' { display: none!important; }\r\n';

    const elemhideSelectors = [];

    let selectorsCount = 0;
    // eslint-disable-next-line no-restricted-syntax
    for (const selector of elemhideRules) {
        selectorsCount += 1;

        elemhideSelectors.push(selector.getContent());

        if (selectorsCount % CSS_SELECTORS_PER_LINE === 0 || !groupElemhideSelectors) {
            elemhideSelectors.push(ELEMHIDE_CSS_STYLE);
        } else {
            elemhideSelectors.push(', ');
        }
    }

    if (elemhideSelectors.length > 0) {
        // Last element should always be a style (it will replace either a comma or the same style)
        elemhideSelectors[elemhideSelectors.length - 1] = ELEMHIDE_CSS_STYLE;
    }

    const elemHideStyle = elemhideSelectors.join('');
    const cssStyle = injectRules.map((x) => x.getContent());

    const styles = [];
    if (elemHideStyle) {
        styles.push(elemHideStyle);
    }

    if (cssStyle) {
        styles.push(...cssStyle);
    }

    return styles;
};
