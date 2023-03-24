import { CosmeticRule } from '@adguard/tsurlfilter';
import { buildStyleSheet } from '../../../../src/pages/content/prepare/css-service';

describe('css-service', () => {
    it('returns one css rule in one array element for inject rules', () => {
        const ruleContent1 = 'body > div { margin-top: 0!important; }';
        const ruleContent2 = 'body > div > div { margin-top: 0!important; }';
        const injectRules = [
            new CosmeticRule(`example.org#$?#${ruleContent1}`, 0),
            new CosmeticRule(`example.org#$?#${ruleContent2}`, 0),
        ];

        const stylesheets = buildStyleSheet([], injectRules, true);

        expect(stylesheets).toEqual([ruleContent1, ruleContent2]);
    });
});
