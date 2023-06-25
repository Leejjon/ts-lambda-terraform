export const handler = async (
    event: any
): Promise<any> => {
    const message = "Hello World3!";
    console.log(`Returning ${message}`);
    return {
        statusCode: 200,
        body: JSON.stringify(message)
    }
}
