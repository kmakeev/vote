# Generated by Django 4.2.5 on 2023-10-05 07:56

from django.db import migrations, models
import django.db.models.deletion


class Migration(migrations.Migration):

    dependencies = [
        ("vote", "0013_alter_meeting_registrationprocess"),
    ]

    operations = [
        migrations.AlterField(
            model_name="meeting",
            name="registrationProcess",
            field=models.ForeignKey(
                null=True,
                on_delete=django.db.models.deletion.DO_NOTHING,
                related_name="meetingRegistrationProcess",
                to="vote.registrationprocess",
                verbose_name="Процесс регистрации пользователей",
            ),
        ),
        migrations.AlterField(
            model_name="registrationprocess",
            name="start_date",
            field=models.DateTimeField(
                blank=True, null=True, verbose_name="Дата начала"
            ),
        ),
    ]