export const handler = async (
    event: any
): Promise<any> => {
    return {
        statusCode: 200,
        body: JSON.stringify("Hello World!")
    }
}
