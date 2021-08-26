import axios from 'axios';

export const toDataUrl = async (url: string): Promise<string> => {
    const response = await axios(url, { responseType: 'blob' });
    return new Promise((resolve, reject) => {
        const reader = new FileReader();
        reader.onloadend = () => resolve(reader.result as string);
        reader.onerror = reject;
        reader.readAsDataURL(response.data);
    });
};
