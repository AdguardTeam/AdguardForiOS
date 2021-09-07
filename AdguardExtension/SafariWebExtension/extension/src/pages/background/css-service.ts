/**
 * Builds stylesheet from rules
 */
import type { CosmeticRule } from '@adguard/tsurlfilter';

export const buildStyleSheet = (
    elemhideRules: CosmeticRule[],
    injectRules: CosmeticRule[],
    groupElemhideSelectors: boolean,
) => {
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
    const cssStyle = injectRules.map((x) => x.getContent()).join('\r\n');

    const styles = [];
    if (elemHideStyle) {
        styles.push(elemHideStyle);
    }

    if (cssStyle) {
        styles.push(cssStyle);
    }

    return styles;
};
