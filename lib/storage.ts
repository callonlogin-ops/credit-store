import { S3Client, PutObjectCommand } from '@aws-sdk/client-s3';

const configured = Boolean(
  process.env.S3_ENDPOINT &&
    process.env.S3_ACCESS_KEY_ID &&
    process.env.S3_SECRET_ACCESS_KEY &&
    process.env.S3_BUCKET &&
    process.env.S3_PUBLIC_URL,
);

const s3 = configured
  ? new S3Client({
      region: process.env.S3_REGION || 'auto',
      endpoint: process.env.S3_ENDPOINT,
      forcePathStyle: false,
      credentials: {
        accessKeyId: process.env.S3_ACCESS_KEY_ID!,
        secretAccessKey: process.env.S3_SECRET_ACCESS_KEY!,
      },
    })
  : null;

function safeName(name: string) {
  return name.normalize('NFKC').replace(/[^a-zA-Z0-9._-]/g, '-').replace(/-+/g, '-');
}

export async function saveUpload(file: File, key: string) {
  if (!s3 || !process.env.S3_BUCKET || !process.env.S3_PUBLIC_URL) {
    throw new Error('Armazenamento S3/R2 não configurado');
  }

  await s3.send(
    new PutObjectCommand({
      Bucket: process.env.S3_BUCKET,
      Key: key,
      Body: Buffer.from(await file.arrayBuffer()),
      ContentType: file.type || 'application/octet-stream',
      ContentDisposition: `attachment; filename="${safeName(file.name)}"`,
    }),
  );

  return `${process.env.S3_PUBLIC_URL.replace(/\/$/, '')}/${key}`;
}

export function uploadKey(userId: string, fileName: string) {
  return `apps/${userId}/${crypto.randomUUID()}-${safeName(fileName)}`;
}

export function iconKey(userId: string, fileName: string) {
  return `icons/${userId}/${crypto.randomUUID()}-${safeName(fileName)}`;
}
