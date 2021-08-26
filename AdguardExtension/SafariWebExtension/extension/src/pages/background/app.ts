import { storage } from './storage';

const PERMISSIONS_MODAL_VIEWED = 'permissions_modal_viewed';

// TODO extract all storage keys in common scheme
const isPermissionsModalViewed = async (): Promise<boolean> => {
    const permissionsModalViewed = await storage.get(PERMISSIONS_MODAL_VIEWED);
    return !!permissionsModalViewed;
};

const setPermissionsModalViewed = async () => {
    await storage.set(PERMISSIONS_MODAL_VIEWED, true);
};

export const app = {
    isPermissionsModalViewed,
    setPermissionsModalViewed,
};
